class NimbleHub::Mongo::StorageService
  def initialize(data_source)
    @client = NimbleHub::Mongo::SystemClient.new
    @collection = @client.collection(data_source.uuid)
  end

  def list
    records = @collection.find({})
    @client.close
    NimbleHub::Mongo::DocumentUtil.format_oid_for_array(records)
  end

  def create(document)
    oid = BSON::ObjectId.new
    document[:_id] = oid
    @collection.insert_one(document)
    record = get_and_format_document(oid)
    @client.close
    record
  end

  def count
    @collection.count
  end

  def exists?(filter)
    @collection.find(filter).count > 0
  end

  def update(filter, document)
    @collection.update_one(filter, document)
  end

  # def update(document)
  #   oid = BSON::ObjectId(document.delete('id'))
  #   @collection.update_one({:_id => oid}, {'$set' => document})
  #   updated_record = get_and_format_document(oid)
  #   @client.close
  #   updated_record
  # end

  def remove(document)
    oid = BSON::ObjectId(document.delete('id'))
    response = @collection.find_one_and_delete({:_id => oid})
    @client.close
    response
  end

  def drop_table
    @collection.drop
    @client.close
  end

  def find(record_id)
    record = @collection.find('_id' => BSON::ObjectId(record_id)).first
    NimbleHub::Mongo::DocumentUtil.format_oid(record)
    @client.close
    record
  end

  def find_by_friendly_id(friendly_url_id)
    record = @collection.find('friendly_url_id' => friendly_url_id).first
    NimbleHub::Mongo::DocumentUtil.format_oid(record)
    @client.close
    record
  end

  def get_and_format_document(oid)
    NimbleHub::Mongo::DocumentUtil.format_oid(@collection.find('_id' => oid).first)
  end

end