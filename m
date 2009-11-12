From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: saquery on ibsim
Date: Thu, 12 Nov 2009 15:43:23 +0200
Message-ID: <20091112134323.GG7192@me>
References: <829ded920911120500j36749e9fpef51e5021949a778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <829ded920911120500j36749e9fpef51e5021949a778-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:30 Thu 12 Nov     , Keshetti Mahesh wrote:
> 
> Is there any limitation in ibsim which is not letting the saquery program
> retrieve all path records available ?

Yes, ibsim doesn't support large (> 256 bytes) RMPP packets yet.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
