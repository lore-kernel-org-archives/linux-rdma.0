From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] ibsim/ibsim.c: Fixed bug regarding undefined commands
Date: Thu, 11 Oct 2012 14:45:26 +0200
Message-ID: <20121011124526.GB6448@calypso>
References: <25EBDF7A-17DB-41FC-9CC8-7F960B6CA304@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25EBDF7A-17DB-41FC-9CC8-7F960B6CA304-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Huang, Parry W." <huang32-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Parry,

On 15:04 Thu 31 May     , Huang, Parry W. wrote:
> In sim_cmd_file and sim_run_console, fixed bug regarding a new line being kept at the end of the input when an unknown command is processed from console or from file.
> 
> Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
