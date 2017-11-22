From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [Regression bug] Can't control IPoIB VLAN interfaces if selinux
 enabled
Date: Wed, 22 Nov 2017 07:43:36 -0600
Message-ID: <b7f5557c-3fea-9ea3-6c03-f8ebddbf7a0b@mellanox.com>
References: <20171122120336.GA11241@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122120336.GA11241-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "refpolicy-F833r1i0HHaU+1/U8MakDg@public.gmane.org" <refpolicy-F833r1i0HHaU+1/U8MakDg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/22/2017 6:03 AM, Honggang LI wrote:
> Hi, Daniel
>
> 409dcf31538a selinux: Add a cache for quicker retreival of PKey SIDs
> ab861dfca165 selinux: Add IB Port SMP access vector
> cfc4d882d417 selinux: Implement Infiniband PKey "Access" access vector
> 3a976fa6767f selinux: Allocate and free infiniband security hooks
> a806f7a1616f selinux: Create policydb version for Infiniband support
> 47a2b338fe63 IB/core: Enforce security on management datagrams
> 8f408ab64be6 selinux lsm IB/core: Implement LSM notification system
> d291f1a65232 IB/core: Enforce PKey security on QPs
> 883c71feaf2e IB/core: IB cache enhancements to support Infiniband security
>
> I think your patchset introduces a regression bug. If we created
> multiple IPoIB VLAN interfaces, the TCP/IP network will be impacted.
>
> 1) Upstream kernel-4.12.0-rc2.409dcf31538a, can't control IPoIB VLAN
> interface over ifdown/ifup. ifup/ifdown over bare IPoIB interface works.
> System Ethernet card can get DHCP IP address and up as expected.
>
> 2) Upstream kernel-4.14.0.0c86a6bd85ff, the TCP/IP network does not
> work at all, as all IP interfaces, which include Ethernet interface and
> IPoIB/VLAN interfaces, will failed to be initialized.
>
> Issue can be reproduced with mlx4/mlx5/qib hardware. IPoIB works
> when selinux disabled.
>
> Please see attachment for details.
>
> thanks

Upstream refpolicy has a patch that allow access to unlabeled PKeys, is it applied in your policy? Even if it is there could additional distro specific changes required, for the unconfined user for example.

https://github.com/TresysTechnology/refpolicy/commit/25a5b2427447eb14edb07ce302217d37528813bc

Apologies if this link is converted into a monstrosity to a Microsoft proxy. It will take you to github.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
