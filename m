From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm/qos.c: Revert port ranges for calls to
 sl2vl_update_table().
Date: Tue, 1 Jun 2010 21:39:28 +0300
Message-ID: <20100601183928.GT28549@me>
References: <20100530235616.GK28549@me>
 <1275404212-5646-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1275404212-5646-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:56 Tue 01 Jun     , Jim Schutt wrote:
> Before commit 051a1dd5 (opensm/osm_qos.c: split switch external and end
> ports setup), osm_qos_setup() would end up calling sl2vl_update_table()
> for output ports 1-N, and inport ports 0-N.
> 
> Commit 051a1dd5 changed this around to be output ports 0-N, and input
> ports 1-N, and an InfiniScale IV-based fabric would log lots of errors
> like these:
> 
>   log_rcv_cb_error: ERR 3111: Received MAD with error status = 0x1C
>   SubnGetResp(SLtoVLMappingTable), attr_mod 0x2300, TID 0xad069
>   Initial path: 0,1,1,4,13 Return path: 0,25,1,7,10
> 
> The attr_mod in every such message has 0x00 in the least significant
> byte, which specifies the output port.
> 
> With the port ranges restored to their old values, the above log messages
> stop.  Hal Rosenstock pointed out that we should not be attempting
> to program a base SP0 with SL2VL maps; see, e.g.,  IBA 1.2.1, section
> 14.2.5.8, page 844.  So, this patch is a full reversion for
> switches supporting base SP0, but only a partial reversion for
> switches supporting enhanced SP0.
> 
> Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
