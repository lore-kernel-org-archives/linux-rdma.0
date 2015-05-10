From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH RFC] IB/core, cma: Nice log-friendly string helpers
Date: Sun, 10 May 2015 12:29:07 +0200
Message-ID: <554F32F3.1070308@sandisk.com>
References: <1431252274-27739-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431252274-27739-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/10/15 12:04, Sagi Grimberg wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..d615e63 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -412,6 +412,32 @@ enum ib_event_type {
>   	IB_EVENT_GID_CHANGE,
>   };
>
> +static const char * const ib_events[] = {
> +	"CQ_ERR",
> +	"QP_FATAL",
> +	"QP_REQ_ERR",
> +	"QP_ACCESS_ERR",
> +	"COMM_EST",
> +	"SQ_DRAINED",
> +	"PATH_MIG",
> +	"PATH_MIG_ERR",
> +	"DEVICE_FATAL",
> +	"PORT_ACTIVE",
> +	"PORT_ERR",
> +	"LID_CHANGE",
> +	"PKEY_CHANGE",
> +	"SM_CHANGE",
> +	"SRQ_ERR",
> +	"SRQ_LIMIT_REACHED",
> +	"QP_LAST_WQE_REACHED",
> +	"CLIENT_REREGISTER",
> +	"GID_CHANGE",
> +};

Array definitions should occur in a .c file instead of in a .h file to 
avoid duplication of the array. Additionally, please consider to use 
designated initializers since that would make the correspondence between 
enum label and text string easier to verify.

> +#define IB_EVENT(event)						\
> +	((event) < ARRAY_SIZE(ib_events) ?			\
> +		ib_events[(event)] : "UNRECOGNIZED_EVENT")
> +

Since a compiler is allowed to use a signed type to implement an enum, 
please cast "event" to an unsigned type before comparing it with the 
array size. Additionally, please consider to define IB_EVENT() as an 
inline function instead of a preprocessor macro.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
