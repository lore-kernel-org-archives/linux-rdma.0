From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: "Virtual" ibnetdiscover command fails
Date: Wed, 6 Feb 2013 14:39:28 +0200
Message-ID: <51124F00.7090500@mellanox.com>
References: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com> <201302052134.17622.jackm@dev.mellanox.co.il> <CAOoYFkF_nE4JNg2ooKXHyO2jqQkjOyczqmBHSehZHtS2tBEFLQ@mail.gmail.com> <511220EA.4020607@mellanox.com> <CAOoYFkHArx4_eH90ehaPupCkXyRjO4KzZ7CGkXkqGm3kSWJfKA@mail.gmail.com> <CAOoYFkEWkxMOsU2VejmYXXcpQY3+LxJCHpBswh6L6fTJgwoe1A@mail.gmail.com> <51122E7D.3030607@mellanox.com> <5112332B.6090200@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5112332B.6090200-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/02/2013 12:40, Sebastian Riemer wrote:
> So if I don't use the unmaintained srptools to get the SRP connection 
> strings but instead send them directly to the initiator to connect to 
> the SRP target, then also SRP should be possible with the virtual 
> GUID. Am I right?

Basically YES, you can use the initiator VM vGID as the source GID for 
the connection.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
