module BranchesHelper
  def format_branch_name(name)
    name.sub(%r(remotes/origin/), '').sub(%r(feature/|features/), '')
  end

  def sort_branches(branch_names)
    branch_names
    #branch_names.sort do |x, y|
      #if (x =~ /feature/ && y =~ /feature/) || (!(x =~ /feature/) && !(y =~ /feature/))
      #  x <=> y
      #else
      #  x =~ /feature/ ? 1 : -1
      #end
    #end
  end
end
