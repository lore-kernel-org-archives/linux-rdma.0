From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 18:30:19 +0200
Message-ID: <20171005163018.tk73i2vr2thaj2pn@linutronix.de>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003154920.31566-2-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On 2017-10-03 12:49:19 [-0300], Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
> index 615be68e40b3..3a30bde9a07b 100644
> --- a/drivers/infiniband/hw/hfi1/pio.c
> +++ b/drivers/infiniband/hw/hfi1/pio.c
> @@ -1421,7 +1421,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
>  
>  	/* there is enough room */
>  
> -	preempt_disable();
> +	preempt_disable_nort();
>  	this_cpu_inc(*sc->buffers_allocated);
>  
>  	/* read this once */

please replace the preempt_disable() / enable with local_lock() /
unlock. The section does not look like it could cope with multiple users
dereferencing / using the same per-CPU variables.

Sebastian
