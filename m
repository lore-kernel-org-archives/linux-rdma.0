From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] opensm: Improve VL use on endport links with
 torus-2QoS routing
Date: Wed, 30 Jan 2013 19:55:35 +0200
Message-ID: <20130130175535.GT2961@calypso.mtl.com>
References: <50B65FD7.3040209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50B65FD7.3040209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:02 Wed 28 Nov     , Hal Rosenstock wrote:
> Currently, torus-2QoS routing utilizes/requires 8 data VLs on endport
> links in order to support 2 QoS levels. While the 8 data VLs are a
> requirement in the subnet core for this, only 2 data VLs are needed on
> endport links (one for each QoS level). This patch series changes
> torus-2QoS routing to only require and use 2 data VLs on such endport links.
> 
> -- Hal
> --

Applied the series. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
