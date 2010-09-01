From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Fix sl2vl configuration
Date: Wed, 1 Sep 2010 15:36:31 +0300
Message-ID: <20100901123631.GP5837@me>
References: <4C505A39.4020201@gmail.com>
 <1280428154.4816.51.camel@sale659.sandia.gov>
 <4C554014.7080603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C554014.7080603-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:36 Sun 01 Aug     , Eli Dorfman (Voltaire) wrote:
> Fix the patch according to Jim's comments
> Changed i,j to in,out to make code readable
> 
> For non-optimal sl2vl configuration in and out ports were reversed.
> For optimal sl2vl added override of default ALL settting with port's
> sl2vl when operational VL was other than the default port.
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
