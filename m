From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [opensm] routing segfault + LMC > 0 routing bug?
Date: Wed, 23 Mar 2011 11:51:47 -0600
Message-ID: <4D8A3333.4040508@sandia.gov>
References: <1300843412.3128.135.camel@auk59.llnl.gov>
 <4D8A1965.40805@sandia.gov> <1300902112.3128.147.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300902112.3128.147.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Albert Chu wrote:
> Hey Jim,
> 
> On Wed, 2011-03-23 at 09:01 -0700, Jim Schutt wrote:
>> Hi Al,
>>

>> Torus-2QoS's use of port->priv is unique because it persists
>> between routing sweeps.  So if another routing engine runs
>> after torus-2QoS and uses port->priv without having ensured
>> that it set it itself, there will be trouble.  9ddcf3419ea
>> was fixing such an issue.
>>
>> I can find only two calls of osm_switch_recommend_path(),
>> and both seem to be to do the right thing, so I think
>> your patch is OK.
> 
> Sounds good.  When reading over your comments about the 2Qos patches
> that affected this area, I wasn't quite sure how you were dealing with
> the p_port->priv, so I was unsure how my patch would affect things.
> 

There's some comments at the top of osm_torus.c,
in the definitions of struct endpoint and struct t_switch,
that describe the rules for how torus-2QoS code can
safely use ->priv.

They may shed some extra light...

-- Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
