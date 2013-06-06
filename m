From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_sa_mcmember_record.c Reduce number of error messages
 the for same event
Date: Thu, 06 Jun 2013 06:08:54 -0400
Message-ID: <51B05FB6.2040507@dev.mellanox.co.il>
References: <7489621d-6395-4e59-896e-d7419aacbd01@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7489621d-6395-4e59-896e-d7419aacbd01@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/3/2013 7:39 AM, Line Holen wrote:
> ERR msg 0x1B22 info is put into the error messages of the tests in the
> same subfunction. No information is lost, but you get one error message
> instead of two.
> 
> Also changed a couple of messages to make them more end user friendly
> 
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
