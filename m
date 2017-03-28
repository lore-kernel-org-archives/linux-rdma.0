From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 28 Mar 2017 14:34:37 +0300
Message-ID: <6300c406-26e6-9040-b793-ade77177f05e@grimberg.me>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com>
 <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0@grimberg.me>
 <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
 <1554c1d1-6bf4-9ca2-12d4-a0125d8c5715@gmail.com>
 <DE927C68B458BE418D582EC97927A92854655137@ORSMSX112.amr.corp.intel.com>
 <3eb5814f-14cb-2b94-adf8-335d4b2eb7e9@grimberg.me>
 <26912d0c-578f-26e9-490d-94fc95bdf259@mellanox.com>
 <DE927C68B458BE418D582EC97927A92855031724@ORSMSX113.amr.corp.intel.com>
 <809f87ab-b787-9d40-5840-07500d12e81a@mellanox.com>
 <DE927C68B458BE418D582EC97927A928550391C2@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A928550419FA@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE927C68B458BE418D582EC97927A928550419FA-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'shahar.salzman'" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org'" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, 'Robert LeBlanc' <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "Sen, Sujoy" <sujoy.sen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Knapp, Anthony J" <anthony.j.knapp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Joseph,

> Hey folks.  Apologies if this message comes through twice, but when I originally sent it the list flagged it as too large due to the dmesg log attachments, and then a coworker just told me they never saw it, so I don't think it made it through on the first attempt.
>
> Please see last note above and dmesg example attached - after more extensive testing with Max's patch we are still able to produce cqe dump errors (at a much lower frequency) as well as a new failure mode involving a crash dump.
>

This is a different issue AFAICT,

Looks like nvmet_sq_destroy() is stuck waiting for
the final reference to drop (which seems to never happen).

I'm trying to look for a code path where this may happen.
Can jyou tell if the backend block device completed all of
its I/O when this happens (can check for active tags in debugfs).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
