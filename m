From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 6/7] IB/mlx4: Create and use another QP1 for
 RoCEv2
Date: Tue, 29 Dec 2015 16:42:12 +0200
Message-ID: <56829BC4.2070709@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-7-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-7-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 3:24 PM, Matan Barak wrote:
> The mlx4 driver uses a special QP to implement the GSI QP. This kind
> of QP allows to build the InfiniBand headers in SW to be put before
> the payload that comes in with the WR. The mlx4 HW builds the packet,
> calculates the ICRC and puts it at the end of the payload. This ICRC
> calculation however depends on the QP configuration which is
> determined when QP is modified (roce_mode during INIT->RTR).
> On the other hand, ICRC verification when packet is received does to
> depend on this configuration.

I don't understand the part of the sentence saying "when packet is 
received does to depend on this configuration"
maybe some typo/s there?

> Therefore, using 2 GSI QPs for send (one for each RoCE version) and 1
> GSI QP for receive are required.

s/2/two/ and s/1/one/ please

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
