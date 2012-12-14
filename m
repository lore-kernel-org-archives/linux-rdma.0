From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Fri, 14 Dec 2012 10:17:27 -0800
Message-ID: <20121214101727.4e4c7b96a0473b186f86e3f3@llnl.gov>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp>
	<50CB2DF3.7020409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB2DF3.7020409-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jens Domke <domke.j.aa@m.titech.ac.jp>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 14 Dec 2012 08:47:31 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 12/14/2012 7:18 AM, Jens Domke wrote:
> > Hello,

[snip]

> 
> >   d) OpenMPI runs are executed with "--mca btl_openib_ib_path_record_service_level 1"
> 
> I'm not familiar with what DFSSSP does to figure out SLs exactly but
> there should be no need to set this.

DFSSSP requires QoS to be configured in OpenSM; "... to equally spread the load on the available SL or virtual lanes."

Ira

[snip]


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
