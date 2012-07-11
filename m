From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/6] IB/mthca: Events received for non-existent
 QPs should generate a warning
Date: Wed, 11 Jul 2012 18:57:04 +0300
Message-ID: <4FFDA250.9090701@mellanox.com>
References: <1342020825-18878-1-git-send-email-ogerlitz@mellanox.com> <1342020825-18878-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUdUm2=UR4N4McTFJ7S9YJPzhH_V4Eym3DFjj5fzXgpYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUdUm2=UR4N4McTFJ7S9YJPzhH_V4Eym3DFjj5fzXgpYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2012 6:40 PM, Roland Dreier wrote:
> On Wed, Jul 11, 2012 at 8:33 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> -               mthca_warn(dev, "Async event for bogus QP %08x\n", qpn);
>> +               mthca_warn(dev, "Async event %d for bogus QP %08x\n",
>> +                         (int) event_type, qpn);
> Looks fine -- just wondering if there's a reason to cast from enum to int?

Nothing special that I can think of, want me to post v1 with that cast 
removed?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
