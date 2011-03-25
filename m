From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] OpenSM - Scatter Ports
Date: Thu, 24 Mar 2011 17:49:40 -0700
Message-ID: <1301014180.3128.222.camel@auk59.llnl.gov>
References: <C9B0E934.B0A4%jared.carr@pnnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C9B0E934.B0A4%jared.carr-MIjBx5DB8Ok@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Carr, Jared F" <jared.carr-MIjBx5DB8Ok@public.gmane.org>
Cc: "Schmidt, Kenneth P" <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-03-24 at 13:13 -0700, Carr, Jared F wrote:
> On 3/24/11 11:35 AM, "Albert Chu" <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> 
> >Architecturally this seems very similar to my
> >"port_shifting"/"remote_guid_sorting" patches I posted earlier.
> 
> Indeed they are very similar as it seems they are both intended to solve
> the same or very similar problem. I think your approach has some
> advantages in that it is potentially more deterministic, and it addresses
> the lmc > 0 scenario.
>
> In simulation the path balance on our topology ends up coming out with a
> slightly better balance using scatter_ports than it does with
> port_shifting. For instance the highest number of paths through a single
> link using port shifting is 11895 and using scatter_ports it is 7121.

I'm also concerned about the conflicts of these patches against opensm.
Some of the conficts are trivial, but there would be two arrays storing
potential routing possibilities in osm_switch_recommend_path().
Needless to say, that's not good.  Integrating scatter_ports with my
"framework" might be good b/c it would also handle LMC > 0 conditions.
However, its perhaps too early to discuss this.  We can discuss more
when the time comes.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
