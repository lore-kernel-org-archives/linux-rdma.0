From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/14] IB/srp: Fix remove_one crash due to resource exhaustion
Date: Thu, 27 Jun 2013 16:45:42 -0700
Message-ID: <CAL1RGDWVgAKSL-GNZCkP1FEt9r_y5QWp+74NzDcga6+tcvWpXw@mail.gmail.com>
References: <51B87501.4070005@acm.org> <51B875A4.7040903@acm.org> <1372366870.32164.30.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372366870.32164.30.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 27, 2013 at 2:01 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Wed, 2013-06-12 at 15:20 +0200, Bart Van Assche wrote:
>> If the add_one callback fails during driver load no resources are
>> allocated so there isn't a need to release any resources. Trying
>> to clean the resource may lead to the following kernel panic:
>
> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

Thanks, I've queued up the 1, 3, and 4/14 patches that Dave acked so far.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
