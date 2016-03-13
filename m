From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for
 maximum SG entries
Date: Sat, 12 Mar 2016 16:38:15 -0800
Message-ID: <56E4B677.6020809@sandisk.com>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1195068688.21605141.1457794577569.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/12/16 06:56, Laurence Oberman wrote:
> [ 6097.205716] ib_srpt IB send queue full (needed 68)
> [ 6097.233325] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12

Hello Laurence,

Are you familiar with the ib_srpt parameter srp_sq_size, a parameter 
that is configurable through configfs ? Please note that changing this 
parameter only affects new sessions but that it not affects any existing 
sessions.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
