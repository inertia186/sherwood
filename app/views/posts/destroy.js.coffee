if <%= @post.persisted? && @post.errors.any? %>
  alert '<%= @post.errors.full_messages.first %>'
else
  id = <%= @post.id %>
  card = angular.element 'post_card[data-post-id=' + id + ']'
  card.fadeOut 'slow'
