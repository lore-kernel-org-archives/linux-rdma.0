From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] dapltest-server segfault seen on recent OFED-1.5.4 daily
 build
Date: Mon, 21 Nov 2011 16:50:34 +0530
Message-ID: <4ECA3402.8030203@chelsio.com>
References: <20111118090155.GB17346@kumars-PC.asicdesigners.com> <54347E5A035A054EAE9D05927FB467F916EA49A5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F916EA49A5-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 11/19/2011 05:18 AM, Davis, Arlin R wrote:
>
>> #0  dapl_llist_remove_entry (head=0x636960, entry=0x7ffff0004bf8) at
[...]
>>
>
> You should have seen a message like "WARNING: overflow event on EVD".
>
> It appears that the default dapltest server allocates too small of a CR EVD for many client test configurations. When it hits the overflow queue case, the CR callback incorrectly frees the CR before it is removed from SP list. In your case, I am guessing that another CR came in on another thread and this memory was reallocated with flink ptr reinitialized.
>
> Please try the following patches.
>
> ---------
> Common: CR EVD overflow causes segfault.
>
> The CR is freed up incorrectly before unlinking with SP.
>
> Signed-off-by: Arlin Davis<arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>
> diff --git a/dapl/common/dapl_cr_callback.c b/dapl/common/dapl_cr_callback.c
> index 3997b38..c58444b 100644
> --- a/dapl/common/dapl_cr_callback.c
> +++ b/dapl/common/dapl_cr_callback.c
> @@ -414,7 +414,6 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
>                                                       (DAT_CR_HANDLE) cr_ptr);
>
>          if (dat_status != DAT_SUCCESS) {
> -               dapls_cr_free(cr_ptr);
>                  (void)dapls_ib_reject_connection(ib_cm_handle,
>                                                   DAT_CONNECTION_EVENT_BROKEN,
>                                                   0, NULL);
> @@ -423,6 +422,7 @@ dapli_connection_request(IN dp_ib_cm_handle_t ib_cm_handle,
>                  dapl_os_lock(&sp_ptr->header.lock);
>                  dapl_sp_remove_cr(sp_ptr, cr_ptr);
>                  dapl_os_unlock(&sp_ptr->header.lock);
> +               dapls_cr_free(cr_ptr);
>                  return DAT_INSUFFICIENT_RESOURCES;
>          }
>
>
> ----------
> dapltest: server CR EVD is too small for multi-client configurations.
>
> Increase default size from 8 to 32.
>
> Signed-off-by: Arlin Davis<arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> diff --git a/test/dapltest/test/dapl_server.c b/test/dapltest/test/dapl_server.c
> index 443425c..92e0d21 100644
> --- a/test/dapltest/test/dapl_server.c
> +++ b/test/dapltest/test/dapl_server.c
> @@ -34,7 +34,7 @@
>   #undef DFLT_QLEN
>   #endif
>
> -#define DFLT_QLEN 8            /* default event queue length */
> +#define DFLT_QLEN 32           /* default event queue length */
>
>   int send_control_data(DT_Tdep_Print_Head * phead,
>                        unsigned char *buffp,
>
>
Thank you for the two patches. I tried the two patches and now, I have 
not seen a segfault till now on dapl-server at least.
However, after about 2 hours of test, some of dapl-client throws below 
error on console:
----
Server Name: 3.4.5.1
Server Net Address: 3.4.5.1
DT_cs_Client: Starting Test ...
FAIL: 16 Server test connections did not report ready.
FAIL: 16 Server test connections did not report ready.
----

dapl-client is stalled at this stage, and needs to be manually killed by 
Ctrl+C.
And below errors are seen on dapl-server console:
----
Test Error: Client_Mem_Info_Send-reaping DTO problem, status = FAILURE
Test Error: Client_Mem_Info_Send-reaping DTO problem, status = FAILURE
Test[b368]: Warning: dat_ep_disconnect (abrupt) #2 error 
DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b368]: dat_evd_free (creq) error: DAT_INVALID_STATE 
DAT_INVALID_STATE_EVD_IN_USE
Test[b368]: Warning: dat_ep_disconnect (abrupt) #3 error 
DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b368]: dat_evd_free (creq) error: DAT_INVALID_STATE 
DAT_INVALID_STATE_EVD_IN_USE
...
----

No message is seen in dmesg on either dapl-server or dapl-client machine.

If I manually kill the dapl-client, and restart it then, test again 
starts fine and runs for about 2 hours or so.


Thanks,
Kumar.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
