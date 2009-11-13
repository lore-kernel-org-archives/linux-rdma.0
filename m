From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
 from ibnd_node_t
Date: Fri, 13 Nov 2009 04:09:23 +0200
Message-ID: <20091113020923.GD7192@me>
References: <1257190401.580.31.camel@auk31.llnl.gov>
 <1257196316.580.33.camel@auk31.llnl.gov>
 <20091106181633.GQ7192@me>
 <1257532494.18550.89.camel@auk31.llnl.gov>
 <20091112163105.GI7192@me>
 <20091112105930.4248e521.weiny2@llnl.gov>
 <20091112225956.GA7192@me>
 <E5EA56B85CF4411FA73984A608918052@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E5EA56B85CF4411FA73984A608918052-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:10 Thu 12 Nov     , Sean Hefty wrote:
> >
> >I'm not asking to make high level life harder :). My point is to not
> >prevent from advanced developers to use available low level too,
> >especially when such preventing requires some extra efforts.
> 
> I haven't been following the details of this thread, but it's very common to
> expose only a portion of a data structure to the user, while keeping some of it
> private.

Of course we can easily find such examples, and also will find others
not less useful where all internal data is exposed (libibumad for
example).

I think that if library interface is designed so that some typical
task/tools (high or low level) cannot be implemented easily than likely
this would be example of a poor interface regardless to how public/private
data structures were separated in this library.

> As long as the lower library allocates the structure and exchanges
> pointers, the interface can be maintained.

Just to be clear - the example of "low level" data triggered this round
of the discussion is node's direct path generated during subnet
discovery (another was discovery BFS graph, but this one "was lost"
already).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
