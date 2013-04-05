From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configure output messages for several configure
 options
Date: Fri, 05 Apr 2013 19:11:08 -0400
Message-ID: <515F5A0C.9000800@dev.mellanox.co.il>
References: <1365097110.5901.36.camel@auk59.llnl.gov>  <515F3470.5090702@dev.mellanox.co.il>  <1365196997.5901.69.camel@auk59.llnl.gov> <1365201155.5901.73.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365201155.5901.73.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/5/2013 6:32 PM, Albert Chu wrote:
> The --enable-console-loopback, --enable-console-socket, --enable-perf-mgr,
> --enable-perf-mgr-profile, and --enable-default-event-plugin did not
> have a checking message or notice message indicating if they were
> enabled/disabled when running configure.
> 
> This made things difficult when perusing old build logs to determine
> if things were properly enabled/disabled.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
