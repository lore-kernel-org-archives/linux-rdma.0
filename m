From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/17] Update rdma/ib_user_verbs.h
Date: Mon, 15 Jan 2018 19:01:13 +0200
Message-ID: <fe2337a1-b02d-cc01-c55d-e6e493ec30ef@dev.mellanox.co.il>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-2-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-2-jgg-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2018 12:13 AM, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> To let us use definitions from the latest kernel headers in followup
> patches.
> 
>  From v4.15-rc7
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   buildlib/RDMA_LinuxHeaders.cmake            |    2 +-
>   buildlib/fixup-include/rdma-ib_user_verbs.h | 1176 +++++++++++++++++++++++++++
>   2 files changed, 1177 insertions(+), 1 deletion(-)
>   create mode 100644 buildlib/fixup-include/rdma-ib_user_verbs.h
> 
> diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
> index ea60b9b55844ea..aa2a89a53d0c2d 100644
> --- a/buildlib/RDMA_LinuxHeaders.cmake
> +++ b/buildlib/RDMA_LinuxHeaders.cmake
> @@ -86,7 +86,7 @@ function(rdma_report_missing_kheaders)
>   endfunction()
>   
>   # This list is topologically sorted
> -rdma_check_kheader("rdma/ib_user_verbs.h" "${DEFAULT_TEST}" NO_SHIM OPTIONAL)
> +rdma_check_kheader("rdma/ib_user_verbs.h" "int main(int argc,const char *argv[]) { return IB_USER_VERBS_EX_CMD_MODIFY_CQ; }")

Any future change in this kernel header will require a change in this 
check as well and also a commit into fixup-include/rdma-ib_user_verbs.h 
with the new kernel code, correct ?

How will people be aware of that and won't miss it ? can we have some 
script that will warn/suggest the expected change upon a kernel change ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
