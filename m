From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/5] rxe_cfg: Use printf() instead of using a loop
Date: Thu, 13 Oct 2016 14:07:17 +0300
Message-ID: <bcdf5ba2-19f9-f926-73dc-5c5a17b2fd7e@mellanox.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <278745ec-1e31-4379-27d9-40f371d30c29@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <278745ec-1e31-4379-27d9-40f371d30c29-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2016 9:39 PM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>  providers/rxe/rxe_cfg | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
> index 0a3dcf16957c..6c414fbda6fd 100755
> --- a/providers/rxe/rxe_cfg
> +++ b/providers/rxe/rxe_cfg
> @@ -241,7 +241,6 @@ sub status_print {
>      my @flen = ();
>      my $num_fields = 0;
>      my $i;
> -    my $j;
>      my $pad;
>      my $line;
>
> @@ -281,9 +280,7 @@ sub status_print {
>  	    else {
>  		print "   ";
>  	    }
> -	    for ($j = 0; $j < $pad; $j++) {
> -		print " ";
> -	    }
> +	    printf("%*s", $pad, "");
>  	}
>  	print "\n";
>      }
>
ack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
