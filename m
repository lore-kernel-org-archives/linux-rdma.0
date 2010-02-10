From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Simplified iWARP user library
Date: Wed, 10 Feb 2010 11:19:36 -0800
Message-ID: <988DA212B4564823A5781B859F3E4D29@amr.corp.intel.com>
References: <OFCE5CAAE4.03598DCF-ONC12576C6.0056753D-C12576C6.0057E286@ch.ibm.com> <ada1vgths3o.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada1vgths3o.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Philip Frey1 <PHF-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>In fact I think it might be a good idea to integrate this simpler API
>into maybe librdmacm -- having both a "full control" low-level API and a
>simpler high-level API available by default would make things easier for
>everyone I think.

FWIW, I agree with this approach, and could probably provide at least some
assistance integrating the API into the librdmacm.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
