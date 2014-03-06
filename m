From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sminfo_rcv.c: send trap144 to a newly found
 MASTER SM when in MASTER state
Date: Thu, 06 Mar 2014 10:28:47 -0500
Message-ID: <5318942F.7030007@dev.mellanox.co.il>
References: <1394110861-6128-1-git-send-email-alexne@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394110861-6128-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/6/2014 8:01 AM, Alex Netes wrote:
> Before this patch, when SM in Master state finds other Master SM, it
> sends trap144 to previously found Master SM/SM with higher priority when
> it was in Discovering/Standby state.
> This can lead to wrong behaviour in a multi-SM topolgy:
> 
> Setup: SM1 with priority 1, SM2 with priority 2, SM3 with priority 3.
> Flow:
> 1. setting SM3 to ignore SMInfo MADs -> SM2 become master
> 2. setting SM2 to ignore SMInfo MADs -> SM1 become master
> 3. setting SM2 to accept SMInfo MADs
> 4. SM2 sends SMInfo to SM1 -> finds that SM1 is master
> 5. SM2 sends trap144 to SM3 instead of sending it to SM1
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
