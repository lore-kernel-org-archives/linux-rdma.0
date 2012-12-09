From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] [RFC] osm_log printing incorrectly assumes that pthread_t
 is not opaque type
Date: Sun, 09 Dec 2012 10:54:48 +0100
Message-ID: <50C45FE8.5020502@acm.org>
References: <alpine.BSF.2.00.1212090125590.64779@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.1212090125590.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/09/12 10:26, Garrett Cooper wrote:
> +#if defined(__FreeBSD__)
> +            "%s %02d %02d:%02d:%02d %06d [%p] 0x%02x -> %s",
> +#else
>               "%s %02d %02d:%02d:%02d %06d [%04X] 0x%02x -> %s",
> +#endif

Please cast the pthread_t value to an unsigned long long or another 
integral type. Such #ifdefs are a pain to maintain.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
