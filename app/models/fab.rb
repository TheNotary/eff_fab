class Fab < ActiveRecord::Base
  has_attached_file :gif_tag,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png"

  validates_attachment_content_type :gif_tag, content_type: /\Aimage\/.*\Z/

  belongs_to :user
  has_many :notes

  accepts_nested_attributes_for :notes, reject_if: :all_blank, :allow_destroy => true

  after_initialize :setup_children

  def setup_children
    3.times { notes.build(forward: true)}
    3.times { notes.build(forward: false)}
  end

  def forward
    notes.where(forward: true)
  end

  def backward
    notes.where(forward: false)
  end

  def period
    # FIXME: this method needs to be changed into a database column
    # this stub is returning the previous monday as a DateTime object
    p_start = (DateTime.now - DateTime.now.wday + 1)
  end

  # This method presents to the view what period this FAB is for
  # Returns something like "February 8, 2016 - February 12, 2016"
  def present_period
    # FIXME: this method is a stub
    p_start = period

    p_end = p_start + 4.days
    s = p_start.strftime("%B %e, %Y - ")
    s += p_end.strftime("%B %e, %Y")
    s
  end


end
