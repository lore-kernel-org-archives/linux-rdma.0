From: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH][MINOR] mstflint/hca_self_test.ofed: Handle lspci output
 for ConnectX3 (on RHEL 6.2)
Date: Tue, 17 Jul 2012 17:02:26 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E86A2D3DC@MTLDAG01.mtl.com>
References: <1342103987-9341-1-git-send-email-lloyd_brown@byu.edu>
 <50058EB2.8060600@byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50058EB2.8060600-8Bzd4dk9+oo@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lloyd Brown <lloyd_brown-8Bzd4dk9+oo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Kladnitsky <orenk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Lloyd

Oren just had a new baby
I hope he will handle it fast when he will return from vacation

Tziporet

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Lloyd Brown
Sent: Tuesday, July 17, 2012 7:12 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH][MINOR] mstflint/hca_self_test.ofed: Handle lspci output for ConnectX3 (on RHEL 6.2)

Just wondering.  Did I send this to the wrong place?  Am I working off the wrong repo?  I expected such a simple patch to fly through, but I haven't heard anything.  If anyone can tell me what I did wrong, I'd be happy to fix it.

Lloyd Brown
Systems Administrator
Fulton Supercomputing Lab
Brigham Young University
http://marylou.byu.edu


On 07/12/2012 08:39 AM, Lloyd Brown wrote:
> Not sure whether the difference is the hardware, or the OS revision, 
> but the lspci output looks like this example, and wasn't being caught:
> 
> 02:00.0 Network controller [0207]: Mellanox Technologies MT27500 
> Family [ConnectX-3]
> 
> Signed-off-by: Lloyd Brown <lloyd_brown-8Bzd4dk9+oo@public.gmane.org>
> ---
>  hca_self_test.ofed |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hca_self_test.ofed b/hca_self_test.ofed index 
> c3e3f22..3c5360d 100755
> --- a/hca_self_test.ofed
> +++ b/hca_self_test.ofed
> @@ -110,7 +110,7 @@ MEM_CON_LSPCI_NAME="Memory controller"
>  MEL_LSPCI_NAME_EXP="${HCA_LSPCI_NAME}|${VPI_LSPCI_NAME}|${NIC_LSPCI_NAME}"
>  
>  # HCA/PCI check
> -NUM_IB_DEV=`lspci 2> /dev/null | grep -E "(${MEL_LSPCI_NAME_EXP}): 
> Mellanox Technolog" | wc -l`
> +NUM_IB_DEV=`lspci 2> /dev/null | grep -E 
> +"(${MEL_LSPCI_NAME_EXP})(\s\[[0-9]+\])?: Mellanox Technolog" | wc -l`
>  NUM_MEM_CON=`lspci 2> /dev/null | grep "${MEM_CON_LSPCI_NAME}: 
> Mellanox Technolog" | wc -l`
>  
>  let "NUM_HCAS=$NUM_IB_DEV + $NUM_MEM_CON"
> @@ -211,7 +211,7 @@ function get_curr_ca_pci_info () {
>      loop_cnt=$1
>  
>      if [ "${g_lspci_was_ran}" == "" ]; then
> -        lspci 2> /dev/null | grep -E "(${MEL_LSPCI_NAME_EXP}|${MEM_CON_LSPCI_NAME}): Mellanox Technolog" > ${G_LSPCI_OUTPUT_FILE}
> +        lspci 2> /dev/null | grep -E 
> + "(${MEL_LSPCI_NAME_EXP}|${MEM_CON_LSPCI_NAME})(\s\[[0-9]+\])?: 
> + Mellanox Technolog" > ${G_LSPCI_OUTPUT_FILE}
>          g_lspci_was_ran=1
>      fi
>      current_pci_info=$(cat ${G_LSPCI_OUTPUT_FILE} | head -$(expr 
> $loop_cnt + 1) | tail -1)
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
