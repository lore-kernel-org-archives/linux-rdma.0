From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Regression bug] Can't control IPoIB VLAN interfaces if selinux
 enabled
Date: Wed, 22 Nov 2017 23:25:48 +0800
Message-ID: <20171122152548.GA19429@dhcp-13-42.nay.redhat.com>
References: <20171122120336.GA11241@dhcp-13-42.nay.redhat.com>
 <b7f5557c-3fea-9ea3-6c03-f8ebddbf7a0b@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b7f5557c-3fea-9ea3-6c03-f8ebddbf7a0b-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "refpolicy-F833r1i0HHaU+1/U8MakDg@public.gmane.org" <refpolicy-F833r1i0HHaU+1/U8MakDg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 22, 2017 at 07:43:36AM -0600, Daniel Jurgens wrote:
> 
> Upstream refpolicy has a patch that allow access to unlabeled PKeys, is it applied in your policy? Even if it is there could additional distro specific changes required, for the unconfined user for example.

Yes, this policy has been applied.

> 
> https://github.com/TresysTechnology/refpolicy/commit/25a5b2427447eb14edb07ce302217d37528813bc
> 
> Apologies if this link is converted into a monstrosity to a Microsoft proxy. It will take you to github.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
