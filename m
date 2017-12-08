From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] register_to_trap(): Increase number of iterations from 3
 to 5
Date: Fri, 8 Dec 2017 13:59:19 -0500
Message-ID: <4ef83e46-7adf-d667-dabb-d075a9fc8f04@dev.mellanox.co.il>
References: <20171208172237.312-1-bart.vanassche@wdc.com>
 <c92fa8ad-7d15-29fa-4c09-b7593e7160cf@dev.mellanox.co.il>
 <e06c1dc0-509e-3fc0-4b0d-49d695a1421e@dev.mellanox.co.il>
 <1512758149.26126.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1512758149.26126.3.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org" <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/8/2017 1:35 PM, Bart Van Assche wrote:
> On Fri, 2017-12-08 at 13:17 -0500, Hal Rosenstock wrote:
>> Given what Nicolas wrote, maybe this should be split into 2 patches with
>> first being refactoring but not changing counter and leave the counter
>> increase for Nicolas.
> 
> Hello Hal,
> 
> How about the patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> [PATCH for rdma-core] register_to_trap(): Specify number of iterations once
> 
> Rearrange the loop in register_to_trap() and also the if-statement
> after that loop such that the number of iterations only occurs once.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
> ---
>  srp_daemon/srp_handle_traps.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
> index 6d94634ef6df..6b36b15cc84c 100644
> --- a/srp_daemon/srp_handle_traps.c
> +++ b/srp_daemon/srp_handle_traps.c
> @@ -550,8 +550,8 @@ static int register_to_trap(struct sync_resources *sync_res,
>  	struct ibv_sge sg;
>  	struct ibv_send_wr *_bad_wr = NULL;
>  	struct ibv_send_wr **bad_wr = &_bad_wr;
> -	int counter = 0;
> -	int rc = 0;
> +	int counter;
> +	int rc;
>  	int ret;
>  	long long unsigned comp_mask = 0;
>  
> @@ -609,7 +609,7 @@ static int register_to_trap(struct sync_resources *sync_res,
>  	p_sa_mad->comp_mask = htobe64(comp_mask);
>  	pr_debug("comp_mask: %llx\n", comp_mask);
>  
> -	do {
> +	for (counter = 3, rc = 0; counter > 0 && rc == 0; counter--) {
>  		pthread_mutex_lock(res->mad_buffer_mutex);
>  		res->mad_buffer->mad_hdr.base_version = 0; // flag that the buffer is empty
>  		pthread_mutex_unlock(res->mad_buffer_mutex);
> @@ -640,10 +640,9 @@ static int register_to_trap(struct sync_resources *sync_res,
>  			}
>  			pthread_mutex_unlock(res->mad_buffer_mutex);
>  		} while (rc == 2); // while old response.
> +	}
>  
> -	} while (rc == 0 && ++counter < 3);
> -
> -	if (counter==3) {
> +	if (counter == 0) {
>  		pr_err("No response to inform info registration\n");
>  		return -EAGAIN;
>  	}
> 

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
