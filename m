From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 05/07] opensm/perfmgr: don't clear data counters in
 PortCounters when ExtendedPortCounters is supported
Date: Sat, 02 Mar 2013 09:13:28 -0500
Message-ID: <51320908.8030603@dev.mellanox.co.il>
References: <20130228170849.fda78e041419da35daa894d0@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130228170849.fda78e041419da35daa894d0-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/28/2013 8:08 PM, Ira Weiny wrote:
> 
> Some hardware apparently clears the data counters of ExtendedPortCounters when
> the PortCounters data counters are cleared.  (Must be using the same hardware
> registers.)
> 
> Therefore, when ExtendedPortCounters is supported on a port; alter the counter
> select of PortCounters to exclude the data counters when clearing.
> 
> Rebased for new series
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
