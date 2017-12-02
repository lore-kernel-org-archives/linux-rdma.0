From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/1] timecounter: Make cyclecounter struct
 part of timecounter struct
Date: Sat, 2 Dec 2017 10:04:58 -0800
Message-ID: <20171202180458.winwznbstsi355ed@localhost>
References: <1512189095-28654-1-git-send-email-sagar.a.kamble@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <1512189095-28654-1-git-send-email-sagar.a.kamble@intel.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: alsa-devel@alsa-project.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <john.stultz@linaro.org>, intel-wired-lan@lists.osuosl.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 02, 2017 at 10:01:35AM +0530, Sagar Arun Kamble wrote:
> There is no real need for the users of timecounters to define cyclecounter
> and timecounter variables separately. Since timecounter will always be
> based on cyclecounter, have cyclecounter struct as member of timecounter
> struct.

Overall, this is a welcome change.  However, it doesn't go far enough,
IMHO, and I'll explain that more below.

> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> index 0247885..35987b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
...

As it stands now, timecounter_init() is used for two totally different
reasons.  Some callers only want to set the time, ...

> @@ -207,7 +207,7 @@ static int mlx4_en_phc_settime(struct ptp_clock_info *ptp,
>  
>  	/* reset the timecounter */
>  	write_seqlock_irqsave(&mdev->clock_lock, flags);
> -	timecounter_init(&mdev->clock, &mdev->cycles, ns);
> +	timecounter_init(&mdev->clock, ns);
>  	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
>  
>  	return 0;

... while others initialize the data structure the first time:

> @@ -274,17 +274,17 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
>  
>  	seqlock_init(&mdev->clock_lock);
>  
> -	memset(&mdev->cycles, 0, sizeof(mdev->cycles));
> -	mdev->cycles.read = mlx4_en_read_clock;
> -	mdev->cycles.mask = CLOCKSOURCE_MASK(48);
> -	mdev->cycles.shift = freq_to_shift(dev->caps.hca_core_clock);
> -	mdev->cycles.mult =
> -		clocksource_khz2mult(1000 * dev->caps.hca_core_clock, mdev->cycles.shift);
> -	mdev->nominal_c_mult = mdev->cycles.mult;
> +	memset(&mdev->clock.cc, 0, sizeof(mdev->clock.cc));
> +	mdev->clock.cc.read = mlx4_en_read_clock;
> +	mdev->clock.cc.mask = CLOCKSOURCE_MASK(48);
> +	mdev->clock.cc.shift = freq_to_shift(dev->caps.hca_core_clock);
> +	mdev->clock.cc.mult =
> +		clocksource_khz2mult(1000 * dev->caps.hca_core_clock,
> +				     mdev->clock.cc.shift);
> +	mdev->nominal_c_mult = mdev->clock.cc.mult;
>  
>  	write_seqlock_irqsave(&mdev->clock_lock, flags);
> -	timecounter_init(&mdev->clock, &mdev->cycles,
> -			 ktime_to_ns(ktime_get_real()));
> +	timecounter_init(&mdev->clock, ktime_to_ns(ktime_get_real()));

I'd like to see two followup patches to this one:

1. Convert timecounter_init() callers to a new timecounter_reset()
   function where the intent is to reset the time.

2. Change timecounter_init() to take the cyclecounter fields as
   arguments.

	void timecounter_init(struct timecounter *tc,
			      u64 (*read)(const struct cyclecounter *cc),
			      u64 mask,
			      u32 mult,
			      u32 shift,
			      u64 start_tstamp);

Then we can clean up all this stuff:

	mdev->clock.cc.read = mlx4_en_read_clock;
	mdev->clock.cc.mask = CLOCKSOURCE_MASK(48);
	mdev->clock.cc.shift = freq_to_shift(dev->caps.hca_core_clock);
	mdev->clock.cc.mult = clocksource_khz2mult(...);

This second step can be phased in by calling the new function
timecounter_initialize() and converting the drivers one by one.

> diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
> index 2496ad4..6daca06 100644
> --- a/include/linux/timecounter.h
> +++ b/include/linux/timecounter.h
...
> @@ -98,7 +98,6 @@ static inline void timecounter_adjtime(struct timecounter *tc, s64 delta)
>  /**
>   * timecounter_init - initialize a time counter
>   * @tc:			Pointer to time counter which is to be initialized/reset
> - * @cc:			A cycle counter, ready to be used.

This "ready to used" requirement should go.  The init() function
should make the instance ready to be used all at once.

Thanks,
Richard
