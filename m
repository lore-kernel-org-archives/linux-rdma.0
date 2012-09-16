From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/6] opensm: Make it possible to enable opensm with
 chkconfig
Date: Sun, 16 Sep 2012 12:10:08 +0300
Message-ID: <20120916091008.GA8243@calypso>
References: <505077FF.6060408@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <505077FF.6060408-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 13:54 Wed 12 Sep     , Bart Van Assche wrote:
> The command "chkconfig $service on" enables a service in the "Default-Start"
> runlevels.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>  scripts/opensm.init.in |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
> index 0c84bd3..9ec08a2 100644
> --- a/scripts/opensm.init.in
> +++ b/scripts/opensm.init.in
> @@ -9,8 +9,8 @@
>  # Provides: opensm
>  # Required-Start: $syslog
>  # Required-Stop:
> -# Default-Start: none
> -# Default-Stop: 0 1 6
> +# Default-Start: 2 3 5
> +# Default-Stop: 0 1 4 6

Why it's needed also to stop on runlevel 4?

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
