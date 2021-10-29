class NimbleHub::Mongo::DocumentUtil
  def self.format_oid(record)
    record['id'] = record['_id'].to_s
    record.delete('_id')
    record
  end

  def self.format_oid_for_array(records)
    formatted_records = []
    records.each do |record|
      internal_records = record['records']

      if internal_records.present?
        internal_records.each { |internal_record| self.format_oid(internal_record) }
      end

      formatted_records.push(self.format_oid(record))
    end
    formatted_records
  end


  def self.format_data(records)
    formatted_records = []
    records.each do |record|
      self.format_oid(record)
      formatted_records.push(record)
    end

    formatted_records
  end
end
