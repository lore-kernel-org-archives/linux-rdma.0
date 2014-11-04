From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2] infiniband-diags: add rdma-ndd daemon
Date: Tue, 04 Nov 2014 14:32:13 +0100
Message-ID: <5458D55D.4080501@acm.org>
References: <1414780065-15267-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414780065-15267-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/31/14 19:27, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> +	format_specifier = 0;
> +	for (tmp = node_desc; tmp[0] != '\0'; tmp++) {
> +		if (tmp[0] == '%' && tmp[1] == 'h') {
> +			format_specifier = 1;
> +			break;
> +		}
> +	}

Hello Ira,

Sorry that I hadn't noticed this before but I think the above code can 
be simplified into "format_specifier = !!strstr(node_desc, "%h")". With 
or without that change, if you want you can add:

Reviewed-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
