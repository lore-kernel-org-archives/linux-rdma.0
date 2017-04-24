From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1] IB/rxe: Add port protocol stats
Date: Mon, 24 Apr 2017 12:01:55 -0400
Message-ID: <1493049715.3041.28.camel@redhat.com>
References: <20170310162356.12518-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170310162356.12518-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-03-10 at 18:23 +0200, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Expose new counters using the get_hw_stats callback.
> We expose the following counters:
> 
> +---------------------+----------------------------------------+
> |      Name           |           Description                  |
> |---------------------+----------------------------------------|
> |sent_pkts            | number of sent pkts                    |
> |---------------------+----------------------------------------|
> |rcvd_pkts            | number of received packets             |
> |---------------------+----------------------------------------|
> |out_of_sequence      | number of errors due to packet         |
> |                     | transport sequence number              |
> |---------------------+----------------------------------------|
> |duplicate_request    | number of received duplicated packets. |
> |                     | A request that previously executed is  |
> |                     | named duplicated.                      |
> |---------------------+----------------------------------------|
> |rcvd_rnr_err         | number of received RNR by completer    |
> |---------------------+----------------------------------------|
> |send_rnr_err         | number of sent RNR by responder        |
> |---------------------+----------------------------------------|
> |rcvd_seq_err         | number of out of sequence packets      |
> |                     | received                               |
> |---------------------+----------------------------------------|
> |ack_deffered         | number of deferred handling of ack     |
> |                     | packets.                               |
> |---------------------+----------------------------------------|
> |retry_exceeded_err   | number of times retry exceeded         |
> |---------------------+----------------------------------------|
> |completer_retry_err  | number of times completer decided to   |
> |                     | retry                                  |
> |---------------------+----------------------------------------|
> |send_err             | number of failed send packet           |
> +---------------------+----------------------------------------+
> 
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
