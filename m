From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add 'ibcheckspeed'
 and 'ibcheckportspeed' to scripts
Date: Tue, 15 Sep 2009 16:04:24 +0300
Message-ID: <4AAF90D8.6070403@gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com> 	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com> 	<20090910090213.6888b7d5.weiny2@llnl.gov> <829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com> 	<20090914110221.7e33b737.weiny2@llnl.gov> <f0e08f230909141151g6e0df176tcb9bca2c040c06c7@mail.gmail.com> 	<4AAF8883.1020900@gmail.com> <829ded920909150541l5505ac0etf18d1937cb54eff1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <829ded920909150541l5505ac0etf18d1937cb54eff1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Keshetti Mahesh wrote:
>> Also it would be useful to find all ports in Disable state.
> 
> iblinkinfo already does this with '-d' option.
> 
It shows all the port that are in Down state - either cable disconnected or port disabled (by ibportstate).

Eli

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
