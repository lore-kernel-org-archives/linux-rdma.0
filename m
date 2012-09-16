From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] osmtest/osmt_multicast.c: Fix 02BF error
Date: Sun, 16 Sep 2012 13:11:51 +0300
Message-ID: <20120916101151.GG8243@calypso>
References: <5047859F.6020402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5047859F.6020402-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 13:02 Wed 05 Sep     , Hal Rosenstock wrote:
> 
> when running osmtest -f m -M 2
> 
> Reported-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Sep 04 20:27:28 920578 [D2499700] 0x02 -> osmt_run_mcast_flow: Checking partial JoinState delete request - removing NonMember (o15.0.1.14)...
> Sep 04 20:27:28 920863 [D2499700] 0x02 -> osmt_run_mcast_flow: Validating Join State removal of Non Member bit (o15.0.1.14)...
> Sep 04 20:27:28 921510 [D2499700] 0x02 -> osmt_run_mcast_flow: Validating Join State update remove (o15.0.1.14)...
> Sep 04 20:27:28 921518 [D2499700] 0x01 -> osmt_run_mcast_flow: ERR 02BF: Validating JoinState update failed. Expected 0x25 got: 0x20
> Sep 04 20:27:28 921527 [D2499700] 0x01 -> osmtest_run: ERR 0152: Multicast Flow failed: (IB_ERROR)
> OSMTEST: TEST "Multicast" FAIL
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
