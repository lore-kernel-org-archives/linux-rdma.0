From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: Call provider listen_destroy function before changing
 state.
Date: Wed, 22 Feb 2012 14:02:49 -0600
Message-ID: <4F4549E9.3090102@opengridcomputing.com>
References: <20120222194337.21025.30754.stgit@build.ogc.int> <1828884A29C6694DAF28B7E6B8A82373374F1119@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373374F1119-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/22/2012 01:50 PM, Hefty, Sean wrote:
>> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
>> index 1a696f7..3b43bba 100644
>> --- a/drivers/infiniband/core/iwcm.c
>> +++ b/drivers/infiniband/core/iwcm.c
>> @@ -340,11 +340,11 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
>>   	spin_lock_irqsave(&cm_id_priv->lock, flags);
>>   	switch (cm_id_priv->state) {
>>   	case IW_CM_STATE_LISTEN:
>> -		cm_id_priv->state = IW_CM_STATE_DESTROYING;
>>   		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
> What does this spinlock protect against if all we do is read the state under it?
>

Probably nothing in this particular path.  It seems to serialize adding/removing references to the qp and manipulating 
cm_id_priv->qp.  But I don't want to revisit the entire serialization of this module. :)

But the point of the patch is to destroy the listening endpoint in the provider _before_ we stop accepting connect requests.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
