From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/5] opensm: change discovery order of switch data
Date: Mon, 03 Feb 2014 14:42:36 -0500
Message-ID: <52EFF12C.8020502@dev.mellanox.co.il>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com> <1391425516-14462-2-git-send-email-alexne@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-2-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/3/2014 6:05 AM, Alex Netes wrote:
> Previously upon receiving GetResp(NodeInfo) of a switch, SM sent
> Get(SwitchInfo) and Get(PortInfo) to all its' ports in parallel. Upon receiving
> GetResp(PortInfo) SM sends Get(PkeyTable). The problem is that we need
> SwitchInfo.PartEnforceCap value to calculate max Pkeys block, so in case
> one of the GetResp(PortInfo) arrives prior to GetResp(SwitchInfo) this
> value won't be set.
> The fix to change the discover order. Upon receiving GetResP(NodeInfo),
> SM sends Get(SwitchInfo). Upon receiving GetResp(SwitchInfo), SM sends
> Get(PortInfo port0). If we don't get GetResp(PortInfo port=0), SM will
> drop the switch, otherwise SM sends Get(PortInfo ExtPorts).
> Moreover, now SM queries for ExtPortInfo and Pkeys only for non-Down
> ports.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
