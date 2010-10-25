From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/cxgb3: When a user QP is marked in error, also
 mark the CQs in error.
Date: Mon, 25 Oct 2010 10:45:00 -0500
Message-ID: <4CC5A5FC.9080009@opengridcomputing.com>
References: <20101021123705.7604.20848.stgit@build.ogc.int> <adar5fhts2b.fsf@cisco.com> <4CC590F9.7010608@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC590F9.7010608-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/25/2010 09:15 AM, Steve Wise wrote:
>
> On 10/23/2010 12:07 AM, Roland Dreier wrote:
>> I applied this, but can you check if there are any alignment/size issues
>> with 32-bit userspace on 64-bit kernel?  Specifically:
>>
>> >   struct iwch_create_cq_resp {
>> >       __u64 key;
>> >       __u32 cqid;
>> >       __u32 size_log2;
>> >  +    __u32 memsize;
>> >   };
>>
>> this structure now has size 20 on i386 (32-bit) but size 24 on x86-64 I
>> think so a 64-bit kernel might falsely think that the 32-bit library was
>> old.
>>
>> The fix is to add a __u32 reserved field at the end of the struct so it
>> always gets padded to 24 bytes.  But I don't want to do that to this
>> patch until you change the userspace library too.
>
> Good catch Roland.  Is there an easy way to configure/build libibverbs 
> and librdmacm as 32bit?   My system only has the 64b versions.  So 
> I'll need to build 32b versions of these to test my fix with a 32b app 
> / 64b kernel.
>
> Steve. 


I built 32b libs and a 32b test app and reproduced what you saw.  I 
added the extra 32b "reserved" field to both the kernel and libcxgb3 
versions of the struct, and the problem is solved.  I've updated my 
libcxgb3 patch and I'm going to publish version 1.30 of libcxgb3 which 
has this patch.   I'll publish and announce once we finish merging the 
kernel side.  Do you need me to resend the kernel patch or can you go 
ahead and add the reserved field?

Like this:

diff --git a/drivers/infiniband/hw/cxgb3/iwch_user.h 
b/drivers/infiniband/hw/cxgb3/iwch_user.h
index 71036cf..a277c31 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_user.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_user.h
@@ -56,6 +56,7 @@ struct iwch_create_cq_resp {
      __u32 cqid;
      __u32 size_log2;
      __u32 memsize;
+    __u32 reserved;
  };

  struct iwch_create_qp_resp {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
