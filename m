From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IPoIB: Avoid multicast join attempts when having
 invalid p_key
Date: Wed, 2 Jul 2014 11:11:20 +0300
Message-ID: <CAJZOPZJJrK4++6u73UpQcQo+HRD_GsuZvqQx1GwWv1Geg1FNrg@mail.gmail.com>
References: <20140625153020.18938.22186.stgit@phlsvslse11.ph.intel.com>
	<53B3B239.8000007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B3B239.8000007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 2, 2014 at 10:18 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Still there is an issue here, please try the following:
> 1. pkey table contains the pkey 8001
> 2. echo 0x8001 > /sys/class/net/ib0/create_child ; ifconfig ib0.8001 1.1.1.1
> up - till now all good.
> 3. change the sm partiotion file, take out the pkey value 8001
> 4. force the sm to send the new event (PKEY_CHANGE_EVENT) via pkill -HUP opensm

Just to make sure... the pkey change IB event isn't "sent" by the SM
to applications. The HUP signal causes opensm to re-read configuration
files and act accordingly, e.g to configure the modified partitioning
scheme. The driver in turn delivers the event to the application.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
