From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: separate router guid resolution
 code
Date: Mon, 05 Oct 2009 12:38:08 -0600
Message-ID: <4ACA3D10.5010909@obsidianresearch.com>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com> <20091004001942.GM17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091004001942.GM17846@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Move off subnet destination (router address) resolution code to separate
> function to improve readability.
>  ...
> +static ib_net64_t find_router(osm_sa_t *sa, ib_net64_t prefix)

Much better.  The *sa argument to find_router() can even be const.

    Rolf
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
