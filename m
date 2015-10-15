From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB: Introduce Work Queue object and its
 verbs
Date: Thu, 15 Oct 2015 17:12:51 +0300
Message-ID: <561FB463.8030602@dev.mellanox.co.il>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
 <1444893410-13242-3-git-send-email-yishaih@mellanox.com>
 <CAG53R5V7u7o+cVQnqhfjXdUjKJRVBiMx5CF3snWAWKG6ZbWMow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5V7u7o+cVQnqhfjXdUjKJRVBiMx5CF3snWAWKG6ZbWMow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/15/2015 12:13 PM, Parav Pandit wrote:
> Just curious, why does WQ need to be bind to PD?
> Isn't ucontext sufficient?
> Or because kcontext doesn't exist, PD serves that role?
> Or Is this just manifestation of how hardware behave?

PD is an attribute of a work queue (i.e. send/receive queue), it's used 
by the hardware for security validation before scattering to a memory 
region. For that, an external WQ object needs a PD, letting the
hardware makes that validation.

> Since you mentioned, "QP can be configured to use "external" WQ
> object", it might be worth to reuse the WQ across multiple QPs of
> different PD?

Correct, external WQ can be used across multiple QPs, in that case its 
PD is used by the hardware for security validation when it accesses to 
the MR, in that case the QP's PD is not in use.

> Because MR and QP validation check has to happen among MR and actual
> QP and might not require that check against WQ.

No, in that case of an external WQ its PD is used and the QP's PD is not 
in use.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
