From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Combining distro IB tools and OFED
Date: Sat, 08 Jun 2013 18:52:14 +0200
Message-ID: <51B3613E.9070407@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <loom.20130608T041932-498@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130608T041932-498-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bruce McKenzie <sales-uUyUjRhFbRmVZhT2dXthUg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/08/13 04:31, Bruce McKenzie wrote:
> ive compiled ubuntu 13.04 to kernel 3.6.11 with OFED 2 from Mellanox, and it
> works ok, performance is a little better with SRP.  Some packages dont seem
> to work, ie srptools and IB-diags some commands fail, which looks like those
> tools havenet been tested with 3.6.11?  or updated.

(changed subject into something I think is more appropriate)

Hello Bruce,

Regarding combining InfiniBand tools from a Linux distribution with 
OFED: the ABI between user space and kernel is different for the 
upstream kernel and several OFED versions. So it's important to install 
IB kernel drivers and user space from the same source: either stick to 
the IB user space and kernel components provided by the Linux 
distribution you are using or use OFED and make sure to enable all user 
space components you need while configuring and building OFED. I think 
the OFED build process takes care of uninstalling redundant distro 
components such that only one version of the user space components 
remains on your system.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
