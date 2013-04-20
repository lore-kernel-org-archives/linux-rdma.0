From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Fri, 19 Apr 2013 23:55:02 -0400
Message-ID: <51721196.9040606@redhat.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com> <515D728B.5010202@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823736F36B8B5@ORSMSX101.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com> <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com> <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com> <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com> <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.
 intel.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD@xmb-rcd-x01.cisco.com> <EF66BBEB19BADC41AC8CCF5F684F07FC44042439@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC44042439-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/19/2013 11:24 AM, Jeff Squyres (jsquyres) wrote:
> On Apr 12, 2013, at 11:40 AM, Jeff Squyres (jsquyres) <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> 
>>> As an aside I like the use of RDMA_MTU_* for these values.  Again to distinguish them from the IBTA values.  But I know that is poor form.
>>
>> So what's the right way to move forward on this?  Is it this:
>>
>> enum ib_mtu {
>>       IB_MTU_256  = 1,
>>       IB_MTU_512  = 2,
>>       IB_MTU_1024 = 3,
>>       IB_MTU_2048 = 4,
>>       IB_MTU_4096 = 5,
>>       RDMA_MTU_1500 = 1500,
>>       RDMA_MTU_9000 =	9000
>> };
> 
> 
> Bump.
> 

This seems reasonable, but still concerns me a bit.  The original
version was flat out wrong because you can't re-arrange any exposed enum
like this without requiring that all user space apps be recompiled.
This is especially true because ibv_mtu_enum_to_int is an inline, so any
compiled programs won't have been updated by a shared library update,
yet the new enum values can end up showing up, so the apps break when
they start seeing -1 as the return value, or when they interpret 1500 as
2048, etc.

I wonder if the correct way forward isn't to leave these two functions
alone (as inlines you can't change them without a recompile anyway).
However, I would officially change the documentation to specify that
both enum ib_mtu in the queue_pair structs and the result of
ib_mtu_enum_to_int is not exact on non-IB link layers and is deprecated
in favor of a new function: ib_qp_mtu() (or similar) that takes a queue
pair and returns the real mtu for that queue pair based on params and
device the queue pair is on (I could also see it being
ibv_dev_mtu(struct ibv_device *) instead if you want to query the mtu
before you make a queue pair instead).  Then for both IBoE and USNIC
devices, I would just store the actual MTU in the internal ibv device
struct and return that when requested.

This maintains 100% back compatibility with existing apps but allows a
path for people to get better performance/utilization by using the new
function instead of the old one.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
