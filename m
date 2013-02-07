From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for 3.8 v3, resend 0/3] IB/SRP patches for kernel 3.8
Date: Thu, 07 Feb 2013 11:15:25 +0100
Message-ID: <51137EBD.5010509@acm.org>
References: <510BDCAA.204@acm.org> <CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com> <5111327F.6050402@acm.org> <CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com> <5112049B.8030406@acm.org> <5112CE60.2030607@mellanox.com> <51136E74.9090209@acm.org> <511376C2.6050100@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511376C2.6050100-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/07/13 10:41, Or Gerlitz wrote:
> (BTW - if the fourth patch that Vu used "save
> & restore host_scribble during error handling" is also needed, maybe you
> add  it to this series, so they are reviewed/accepted together).

Hello Or,

The three patches I posted guarantee timely host removal even without 
the host_scribble patch. Even if srp_abort() would not have aborted a 
request because the host_scribble field had been overwritten, 
srp_reset_host() will be invoked later on and will finish such a request 
properly.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
