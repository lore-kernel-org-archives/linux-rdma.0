From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 11:49:28 -0500
Message-ID: <56685B98.5080803@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <56682392.5000302@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810A2@CRSMSX101.amr.corp.intel.com>
 <56683080.1090801@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810D9@CRSMSX101.amr.corp.intel.com>
 <5668354B.4090903@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB18581111@CRSMSX101.amr.corp.intel.com>
 <56683C6C.7070106@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185811ED@CRSMSX101.amr.corp.intel.com>
 <5668458A.7020809@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7F21@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE7F21-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/9/2015 11:26 AM, Hefty, Sean wrote:
>>> I mean that the user needs to investigate why the fabric is not working
>> out of box.
>>
>> My point is that an educated admin should _know_ to configure in these
>> cases and that debug is only when things are broken not by default in
>> these more complex cases. This means the limitations of the out of box
>> approach needs to be explained in the docs.
> 
> When IP addresses are used, the corresponding pkey is used.  The issue this patch is addressing is the mapping of 'hostnames' to pkeys, as show in this ibacm_addr.cfg example:
> 
> #Name      device port pkey
> cst-lin0   mlx4_0 1    default
> cst-lin0-1 mlx4_0 1    default
> cst-lin0-2 mlx4_0 2    default
> 
> Currently, 'default' is hard-coded to a pkey of 0xffff.  The intent is to define a better default value.  Kaike has suggested this be the new default:
> 
> 1. Find the first non-management full-member pkey;

By "non-management full-member pkey", I think you mean "pkey which is
other than a full member of default (0x7fff) partition".

> 2. If it fails, find pkey 0xffff;

To me, finding pkey 0xffff is better/safer than assuming it's in index 0
although it's likely there.

> 3. If pkey 0xffff is not available, use the first pkey.
> 
> Is there better alternative for what default should be?  

Order of 1 and 2 depends on use models for full default partition and
other partitions. Reversing 1 and 2 (full default partition first) would
handle the most common use models and handles Jason's case.

The only common case that I'm aware of where that might fall down is in
the virtualized case. I'm not sure what policy is best there and would
need to think about that scenario some more (and there is more
fundamental issue with ACM in those environments).

> Jason was suggesting use pkey[0], which seems less robust in theory, but is simple and may cover the vast majority of real use cases.

Seems less robust to me too.

> The fewer cases where manual configuration is necessary, the fewer emails I receive, and the better off I am.  :)

Understood.

-- Hal

> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
