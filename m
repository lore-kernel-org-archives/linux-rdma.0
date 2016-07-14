From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send
 limit
Date: Thu, 14 Jul 2016 07:26:03 +0700
Message-ID: <58ae3b26-52dc-662e-2a60-b2ca68b7d12e@sandisk.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com>
 <7b9f8bca-38fa-b289-a92f-19cf93955e32@sandisk.com>
 <57860AA4.6070303@grimberg.me>
 <700c95fd-ea9f-e83c-389f-30e1ca846dac@sandisk.com>
 <578618BD.5080101@grimberg.me>
 <002101d1dd12$f6ee0980$e4ca1c80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002101d1dd12$f6ee0980$e4ca1c80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/13/2016 09:29 PM, Steve Wise wrote:
> I'll be sure and test v3 of this series on cxgb4 (please CC me).

Thanks Steve. I will CC you for v3 of this series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
