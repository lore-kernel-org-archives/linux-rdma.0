From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 5/9] IB/mlx4: Handle well-known-gid in mad_demux processing
Date: Sun, 6 Nov 2016 22:51:21 +0200
Message-ID: <CAJ3xEMgvvcuXjJ7gos=XoFj2s2zk=8z49P8A5Edba3wmDf_fhw@mail.gmail.com>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
 <1478375842-21513-6-git-send-email-leonro@mellanox.com> <d339ee5f-bf7e-dc35-3dd0-c6ff13a222b4@dev.mellanox.co.il>
 <20161106204107.00005742@dev.mellanox.co.il> <CAJ3xEMjLvo+LVFS0WL-K=m34-_1Tc0=pArOgELXmxqdtN871TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjLvo+LVFS0WL-K=m34-_1Tc0=pArOgELXmxqdtN871TA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 6, 2016 at 10:46 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Nov 6, 2016 at 8:41 PM, jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On Sat, 5 Nov 2016 17:03:25 -0400
>> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>>> Isn't the SA well-known GID the concatenation of the subnet prefix
>>> (which isn't necessarily the default link local one) and the GUID
>>> 0x0200000000000002 ?
>>
>> You are correct regarding the subnet prefix (it should be the port's
>> current subnet prefix, and not the default subnet prefix).
>>
>> Regarding the SM GUID, the version of the Virtualization Annex that I
>> worked with (v17 -- Feb 16, 2015) states:
>> SM GID  A well-known GID that is associated with the SM,
>> comprising the concatenation of the Subnet prefix and the GUID 0x2. The
>> SM GID is never present in any GID Table.
>>
>> Has the SM GUID value changed (0x2 -->0x0200000000000002) in the Annex
>> since v17? (I'm not a member of the MGTWG workgroup, so I don't have
>> access to the most recent version).
>
> Jack, I see that in Linux we've picked the value Hal is mentioning,
> see Eli Cohen's commit a0c1b2a3 "IB/core: Support accessing SA in
> virtualized environment". You probably can talk to Eli to get where
> things stand.

yep, looking now on the annex I see the following:

SM GID -- A well-known GID that is associated with the SM, comprising
the concatenation of the Subnet prefix and the GUID
0x0200000000000002. The
SM GID is never present in any GID Table. If the SubnetPrefix is modified
by the SM, the SM GID is updated implicitly
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
