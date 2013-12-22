From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1] IB/usnic: Fix userspace/kernel ABI
 alignment discrepancy
Date: Sun, 22 Dec 2013 22:54:08 +0000
Message-ID: <87E04617-ADBF-4CCB-B909-EC8A7744B288@cisco.com>
References: <BB49315F-37F6-4B91-9374-E7C886DA2B3D@cisco.com>
 <52B564C0.2090606@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B564C0.2090606-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Content-ID: <5310A126EB643241BE33719F64B41E3A-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Gaaah.  Yes, you are right.  That should say '36 bytes instead of 32 bytes.'

I won't re-spin bc the error is in the version change description, going from V0 to V1, which will not go in the commit log.

Upinder

On Dec 21, 2013, at 1:52 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
 wrote:

> On 12/21/13 03:05, Upinder Malhi (umalhi) wrote:
>> Change from V0:
>> Make reserved field 9 bytes instead of 8 bytes.
>> 
>> This patch depends on http://www.spinics.net/lists/linux-rdma/msg18193.html.
>> 
>> Change the type of the reserve field to u32 from u64 in
>> usnic_ib_create_qp_resp bc u64 will align differently for
>> 32 and 64 bit archs.  And reserve even more space for future
>> expansion.
>> 
>> Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>> ---
>> drivers/infiniband/hw/usnic/usnic_abi.h | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
>> index 730a371..6c56fbf 100644
>> --- a/drivers/infiniband/hw/usnic/usnic_abi.h
>> +++ b/drivers/infiniband/hw/usnic/usnic_abi.h
>> @@ -21,7 +21,7 @@
>> #define USNIC_ABI_H
>> 
>> /* ABI between userspace and kernel */
>> -#define USNIC_UVERBS_ABI_VERSION	3
>> +#define USNIC_UVERBS_ABI_VERSION	4
>> 
>> #define USNIC_QP_GRP_MAX_WQS		8
>> #define USNIC_QP_GRP_MAX_RQS		8
>> @@ -67,7 +67,7 @@ struct usnic_ib_create_qp_resp {
>> 	u32				rq_idx[USNIC_QP_GRP_MAX_RQS];
>> 	u32				cq_idx[USNIC_QP_GRP_MAX_CQS];
>> 	u32				transport;
>> -	u64				reserved;
>> +	u32				reserved[9];
>> };
>> 
>> #endif /* USNIC_ABI_H */
> 
> Sorry but to me it seems like the patch description does not match the
> patch itself. In the patch I see an increase of the size of "reserved"
> from 8 to 36 bytes while the description says that the size of that
> member has been increased from 8 to 9 bytes ?
> 
> Bart.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
