From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Unable to Connect Using Active Speed 2.5 Gbps and Active Width of 1
Date: Mon, 28 Mar 2011 18:01:23 +0000 (UTC)
Message-ID: <loom.20110328T194956-774@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In trying to support various speeds with my application, I attempted to change
the speed and width of Infiniband card using ibportstate.  I had difficulty with
the reliability of the setting changes working.  I found that I needed to set
"force_link_speed 0" in /etc/ofed/opensm.conf.  Once that change as made the
service restarted, I was able to reliably change settings on the cards.

All was well until I changed the card to 2.5 x1.  At this point, I was unable to
ping the other machine.  Both PCs show that the link is up and active, but I am
unable to get any communication between the two.  I tried both ping and ibping
with no success.  I brought the interfaces down and back up, but that did not
solve the issue.

I have been using the following commands (as root) to adjust the speed and width:

ibportstate -C mlx4_0 -D 0 1 speed [1-7]
ibportstate -C mlx4_0 -D 0 1 width [1|2]
ibportstate -C mlx4_0 -D 0 1 reset

I was able to both ping and ibping when using the following speed and width
configurations:

 2.5 Gbps x4
 5.0 Gbps x1
 5.0 Gbps x4
10.0 Gbps x1
10.0 Gbps x4

The only setting configuration that does not work is the 2.5 x1.

Is there something that I am missing?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
