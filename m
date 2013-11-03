From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 02/10] IB/core: Introduce Signature Verbs API
Date: Sun, 3 Nov 2013 14:15:36 +0200
Message-ID: <52763E68.2040605@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-3-git-send-email-sagig@mellanox.com> <5273F6F4.3000300@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5273F6F4.3000300-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/1/2013 8:46 PM, Bart Van Assche wrote:
> On 31/10/2013 5:24, Sagi Grimberg wrote:
>> +/**
>> + * Signature T10-DIF block-guard types
>> + */
>> +enum ib_t10_dif_bg_type {
>> +    IB_T10DIF_CRC,
>> +    IB_T10DIF_CSUM
>> +};
>
> In SPC-4 paragraph 4.22.4 I found that the T10-PI guard is the CRC 
> computed from the generator polynomial x^16 + x^15 + x^11 + x^9 + x^8 
> + x^7 + x^5 + x^4 + x^2 + x + 1. Could you tell me where I can find 
> which guard computation method IB_T10DIF_CSUM corresponds to ?
>
> Bart.

The IB_T10DIF_CSUM  computation method corresponds to IP checksum rules. 
this is aligned with SHOST_DIX_GUARD_IP guard type.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
