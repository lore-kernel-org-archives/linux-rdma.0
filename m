From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics
 on one opensm server
Date: Mon, 05 Mar 2012 07:52:23 -0500
Message-ID: <4F54B707.1070606@dev.mellanox.co.il>
References: <4F4DB11C.5080203@redhat.com> <20120229112229.136f25b7.weiny2@llnl.gov> <4F4E80B4.5010508@redhat.com> <20120301021501.GB961@bukharin.us.cray.com> <4F4F7A4B.4060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4F7A4B.4060007-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/1/2012 8:31 AM, Doug Ledford wrote:
> I would say we are simply getting to the point where we *know* we need
> opensm to handle more than one fabric from a single instance ;-)

Why does a single OpenSM need to handle multiple subnets/fabrics ?
What's the issue with running multiple OpenSMs with each handling it's
own subnet/fabric ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
