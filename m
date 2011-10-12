From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: OpenSM plugin patch request
Date: Wed, 12 Oct 2011 15:13:59 -0700
Message-ID: <20111012151359.f1876bd3.weiny2@llnl.gov>
References: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF@tacc.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think this is a reasonable idea.

Comment on the patch.

-	OSM_EVENT_ID_MAX
+	OSM_EVENT_ID_MAX,
+	OSM_EVENT_ID_LIGHT_SWEEP_START,	
+	OSM_EVENT_ID_LIGHT_SWEEP_DONE,	

Traditionally the "MAX" value in the enum is kept at the end.

Ira


On Wed, 12 Oct 2011 14:31:07 -0700
Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org> wrote:

> Hello,
> 
> Would it be possible to consider exposing light-sweep events to the current OpenSM plugin interface?  Something along the lines of the attached patch is what we are using locally against opensm-3.3.9.
> 
> The motivation is to support a plugin module we have written to expose topology information to a query service which can be used by MPI stacks (in user-space) for topology-aware optimization and for topology-aware scheduling via batch systems. 
> 
> Thanks for the consideration,
> 
> Karl
> 


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
